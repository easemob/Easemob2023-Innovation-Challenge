package com.imchat.chanttyai.ui.activity;

import android.content.Context;
import android.content.Intent;
import android.view.MenuItem;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentManager;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.imchat.chanttyai.R;
import com.imchat.chanttyai.adapters.FragmentAdapter;
import com.imchat.chanttyai.base.BaseActivity;
import com.imchat.chanttyai.base.BaseFragment;
import com.imchat.chanttyai.databinding.ActivityMainBinding;
import com.imchat.chanttyai.ui.fragment.ConversationFragment;
import com.imchat.chanttyai.ui.fragment.HomeFragment;
import com.imchat.chanttyai.utils.DisplayUtil;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends BaseActivity<ActivityMainBinding> {

    public static void start(Context context) {
        context.startActivity(new Intent(context, MainActivity.class));
    }

    private static final int[] tabIds = {R.id.action_home, R.id.action_conversation};

    @Override
    protected ActivityMainBinding getViewBinding() {
        return ActivityMainBinding.inflate(getLayoutInflater());
    }

    @Override
    protected void initView() {

    }


    @Override
    protected void initData() {
        initNav();
    }

    private void initNav() {
        mBinding.nav.setItemIconTintList(null);
        //去除tab 长按
        DisplayUtil.hideNavToast(mBinding.nav, tabIds);

        List<BaseFragment> fragmentList = new ArrayList<>();
        fragmentList.add(new HomeFragment());
        fragmentList.add(new ConversationFragment());

        // FragmentPagerAdapter 来处理多个 Fragment 页面
        FragmentAdapter fragmentPagerAdapter = new FragmentAdapter(mFragmentManager, fragmentList);
        // viewPager 设置 adapter
        mBinding.vp.setAdapter(fragmentPagerAdapter);

        mBinding.vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                mBinding.nav.getMenu().getItem(position).setChecked(true);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        mBinding.vp.setOffscreenPageLimit(fragmentList.size());

        // navigationView点击事件
        mBinding.nav.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                mBinding.vp.setCurrentItem(getPos(item.getItemId()));
                return true;
            }
        });
    }

    private int getPos(int id) {
        for (int i = 0; i < tabIds.length; i++) {
            if (id == tabIds[i]) return i;
        }
        return 0;
    }

    @Override
    protected void initListener() {

    }
}
