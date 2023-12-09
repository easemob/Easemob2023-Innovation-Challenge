package com.imchat.chanttyai.listeners;

import android.util.TypedValue;
import android.widget.TextView;

import com.google.android.material.tabs.TabLayout;

public class TlOnPageChangeListener implements TabLayout.OnTabSelectedListener {
    private float selectedFontSize; // 选中状态下的字体大小
    private float unselectedFontSize; // 非选中状态下的字体大小
    private TabLayout mTabLayout;

    public TlOnPageChangeListener(float selectedFontSize, float unselectedFontSize) {
        this.selectedFontSize = selectedFontSize;
        this.unselectedFontSize = unselectedFontSize;
    }


    private void updateTabTextSize(TabLayout.Tab tab) {
        if (tab != null) {
            TextView tabTextView = (TextView) tab.getCustomView();
            if (tabTextView != null) {
                float fontSize = (tab.isSelected()) ? selectedFontSize : unselectedFontSize;
                tabTextView.setTextSize(TypedValue.COMPLEX_UNIT_SP, fontSize);
            }
        }
    }

    @Override
    public void onTabSelected(TabLayout.Tab tab) {
        updateTabTextSize(tab);
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab) {
        updateTabTextSize(tab);
    }

    @Override
    public void onTabReselected(TabLayout.Tab tab) {

    }
}
