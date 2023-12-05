package com.kangaroo.ktdemo.widget

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.kangaroo.ktdemo.ui.page.main.MainActivity
import com.kangaroo.ktdemo.ui.page.main.mBottomTabItems
import com.kangaroo.ktdemo.ui.theme.Pink40
import com.kangaroo.ktdemo.ui.theme.Pink80
import com.kangaroo.ktdemo.ui.theme.Purple40
import com.kangaroo.ktdemo.ui.theme.Purple80
import com.kangaroo.ktdemo.ui.theme.TestoneTheme

/**
 * @author  SHI DA WEI
 * @date  2023/10/24 9:33
 */
data class BottomItem(val label: String, val selectItemRes: ImageVector)

@Composable
fun BottomBarWidget(
    selectedPosition: Int,
    bottomItems: List<BottomItem>,
    onItemSelected: (position: Int) -> Unit
) {
    NavigationBar() {
        bottomItems.forEachIndexed { index, item ->
            NavigationBarItem(
                selected = selectedPosition == index,
                onClick = { onItemSelected.invoke(index) },
                icon = {
                    var iconColor = Purple80
                    if (selectedPosition == index) {
                        iconColor = Purple40
                    }
                    Icon(
                        imageVector = item.selectItemRes,
                        contentDescription = null,
                        modifier = Modifier.size(24.dp).padding(bottom = 4.dp),
                        tint = iconColor,
                    ) },
                label = {
                    val labelStyle = if (selectedPosition == index) {
                        TextStyle(
                            fontWeight = FontWeight.Medium,
                            color = Pink80,
                            fontSize = 11.sp
                        )
                    } else {
                        TextStyle(
                            fontWeight = FontWeight.Normal,
                            color = Pink40,
                            fontSize = 11.sp
                        )
                    }
                    Text(
                        text = bottomItems[index].label,
                        style = labelStyle,
                    )
                },
            )


        }
    }
}

@Preview(showBackground = true)
@Composable
fun PreviewBottomBarWidgetLight() {
    TestoneTheme(darkTheme = false) {
        BottomBarWidget(0, mBottomTabItems, {})
    }
}

@Preview(showBackground = true)
@Composable
fun PreviewBottomBarWidgetNight() {
    TestoneTheme(darkTheme = true) {
        BottomBarWidget(1, mBottomTabItems, {})
    }
}