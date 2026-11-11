package com.godot.game

import android.app.Activity
import android.os.Bundle
import android.widget.TextView


class PermissionsRationaleActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val text = TextView(this)

        text.text = """
            Walking Worlds uses your step count from Health Connect
            to convert physical activity into in-game rewards.

            Walking Worlds only reads your step count.
            It does not modify or delete your health data.
        """.trimIndent()

        text.textSize = 18f
        text.setPadding(40, 80, 40, 40)

        setContentView(text)
    }
}