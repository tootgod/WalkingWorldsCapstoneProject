package com.godot.game

import android.app.Activity
import android.os.Build
import android.os.ext.SdkExtensions
import android.view.View

import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher

import androidx.health.connect.client.records.metadata.DataOrigin
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.UsedByGodot

import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId



class HealthConnectPlugin(godot: Godot) : GodotPlugin(godot) {

    @Volatile
    private var todayStepsReady: Boolean = false

    @Volatile
    private var lastError: String = ""

    // ---------------------------------------------------------
    // Health Connect permissions
    // ---------------------------------------------------------

    private val permissions = setOf(
        HealthPermission.getReadPermission(StepsRecord::class)
    )


    // ---------------------------------------------------------
    // Health Connect client
    // ---------------------------------------------------------

    private val healthConnectClient: HealthConnectClient by lazy {
        HealthConnectClient.getOrCreate(activity!!)
    }


    // ---------------------------------------------------------
    // Stored values
    // ---------------------------------------------------------

    @Volatile
    private var todaySteps: Long = 0

    @Volatile
    private var stepPermissionGranted: Boolean = false

    @Volatile
    private var rawStepRecordCount: Int = -1

    @Volatile
    private var rawStepTotal: Long = 0

    @Volatile
    private var rawStepSources: String = ""


    // ---------------------------------------------------------
    // Permission launcher
    // ---------------------------------------------------------

    private var permissionLauncher:
        ActivityResultLauncher<Set<String>>? = null


    // ---------------------------------------------------------
    // Godot plugin name
    // ---------------------------------------------------------

    override fun getPluginName(): String {
        return "HealthConnect"
    }


    // ---------------------------------------------------------
    // Initialize Android permission launcher
    // ---------------------------------------------------------

    override fun onMainCreate(activity: Activity?): View? {

        if (activity is ComponentActivity) {

            permissionLauncher =
                activity.registerForActivityResult(
                    PermissionController
                        .createRequestPermissionResultContract()
                ) { grantedPermissions ->

                    stepPermissionGranted =
                        grantedPermissions.containsAll(permissions)

                    println(
                        "Health Connect permission result: " +
                        stepPermissionGranted
                    )
                }
        }

        return super.onMainCreate(activity)
    }


    // ---------------------------------------------------------
    // Check Health Connect permission
    // ---------------------------------------------------------

    @UsedByGodot
    fun updatePermissionStatus() {

        CoroutineScope(Dispatchers.IO).launch {

            try {

                val granted =
                    healthConnectClient
                        .permissionController
                        .getGrantedPermissions()

                stepPermissionGranted =
                    granted.containsAll(permissions)

            } catch (e: Exception) {

                e.printStackTrace()
            }
        }
    }


    @UsedByGodot
    fun hasStepPermission(): Boolean {
        return stepPermissionGranted
    }


    @UsedByGodot
    fun isPermissionLauncherReady(): Boolean {
        return permissionLauncher != null
    }


    // ---------------------------------------------------------
    // Request Health Connect permission
    // ---------------------------------------------------------

    @UsedByGodot
    fun requestStepPermission() {

        activity?.runOnUiThread {

            if (permissionLauncher != null) {

                permissionLauncher?.launch(permissions)

            } else {

                println("Permission launcher is not ready")
            }
        }
    }


    // ---------------------------------------------------------
    // Read today's total step count
    // ---------------------------------------------------------

    @UsedByGodot
    fun updateTodaySteps() {

        todayStepsReady = false
        lastError = ""

        CoroutineScope(Dispatchers.IO).launch {

            try {

                val act = activity
                    ?: throw IllegalStateException("activity is null")

                val status = HealthConnectClient.getSdkStatus(act)
                if (status != HealthConnectClient.SDK_AVAILABLE) {
                    throw IllegalStateException(
                        "Health Connect not available, status=$status"
                    )
                }

                val zone = ZoneId.systemDefault()

                val dayStart = LocalDate.now()
                    .atStartOfDay(zone)
                    .toInstant()

                val now = Instant.now()

                var total = 0L
                var pageToken: String? = null

                do {
                    val response = healthConnectClient.readRecords(
                        ReadRecordsRequest(
                            recordType = StepsRecord::class,
                            timeRangeFilter = TimeRangeFilter.between(
                                dayStart,
                                now
                            ),
                            pageToken = pageToken
                        )
                    )

                    for (record in response.records) {
                        // 오늘 0시 이전에 시작한 기록은 오늘 부분만 비례 계산
                        val start = record.startTime
                        val end = record.endTime

                        if (start >= dayStart) {
                            total += record.count
                        } else {
                            val totalMs = (end.toEpochMilli() - start.toEpochMilli())
                                .coerceAtLeast(1L)
                            val todayMs = (end.toEpochMilli() - dayStart.toEpochMilli())
                                .coerceAtLeast(0L)
                            total += record.count * todayMs / totalMs
                        }
                    }

                    pageToken = response.pageToken
                } while (pageToken != null)

                todaySteps = total
                todayStepsReady = true

            } catch (e: Exception) {

                lastError = "${e.javaClass.simpleName}: ${e.message}"
                e.printStackTrace()
            }
        }
    }
    


    @UsedByGodot
    fun isTodayStepsReady(): Boolean {
        return todayStepsReady
    }


    @UsedByGodot
    fun getLastError(): String {
        return lastError
    }
        


    @UsedByGodot
    fun getTodaySteps(): Long {
        return todaySteps
    }


    // ---------------------------------------------------------
    // Get Android Health Connect SDK Extension version
    // ---------------------------------------------------------

    @UsedByGodot
    fun getHealthSdkExtensionVersion(): Int {

        return if (Build.VERSION.SDK_INT >= 34) {

            SdkExtensions.getExtensionVersion(
                Build.VERSION_CODES.UPSIDE_DOWN_CAKE
            )

        } else {

            0
        }
    }


    // ---------------------------------------------------------
    // DEBUG:
    // Read raw StepsRecord data from the last 7 days
    // ---------------------------------------------------------

    @UsedByGodot
    fun debugStepRecords() {

        CoroutineScope(Dispatchers.IO).launch {

            try {

                val zone =
                    ZoneId.systemDefault()

                val startTime =
                    LocalDate.now()
                        .minusDays(7)
                        .atStartOfDay(zone)
                        .toInstant()

                val endTime =
                    Instant.now()

                val response =
                    healthConnectClient.readRecords(
                        ReadRecordsRequest(
                            recordType =
                                StepsRecord::class,

                            timeRangeFilter =
                                TimeRangeFilter.between(
                                    startTime,
                                    endTime
                                )
                        )
                    )

                rawStepRecordCount =
                    response.records.size

                rawStepTotal =
                    response.records.sumOf {
                        it.count
                    }

                rawStepSources =
                    response.records
                        .map {
                            it.metadata
                                .dataOrigin
                                .packageName
                        }
                        .distinct()
                        .joinToString(", ")

            } catch (e: Exception) {

                rawStepRecordCount = -2

                rawStepTotal = 0

                rawStepSources =
                    "${e.javaClass.simpleName}: ${e.message}"

                e.printStackTrace()
            }
        }
    }


    // ---------------------------------------------------------
    // DEBUG getters
    // ---------------------------------------------------------

    @UsedByGodot
    fun getRawStepRecordCount(): Int {
        return rawStepRecordCount
    }


    @UsedByGodot
    fun getRawStepTotal(): Long {
        return rawStepTotal
    }


    @UsedByGodot
    fun getRawStepSources(): String {
        return rawStepSources
    }
}