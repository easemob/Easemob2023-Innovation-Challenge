package com.imchat.chanttyai.adapters;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import com.imchat.chanttyai.base.BaseFragment;

import java.util.List;

public class FragmentAdapter extends FragmentPagerAdapter {

    private List<BaseFragment> mFragmentList;

    public FragmentAdapter(@NonNull FragmentManager fm,List<BaseFragment> fragmentList) {
        super(fm);
        mFragmentList = fragmentList;
    }

    @NonNull
    @Override
    public Fragment getItem(int position) {
        return mFragmentList.get(position);
    }

    @Override
    public int getCount() {
        return mFragmentList.size();
    }
}
