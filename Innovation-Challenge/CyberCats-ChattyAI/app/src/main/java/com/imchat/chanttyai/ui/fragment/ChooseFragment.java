package com.imchat.chanttyai.ui.fragment;

import android.view.LayoutInflater;
import android.view.ViewGroup;

import androidx.recyclerview.widget.LinearLayoutManager;

import com.imchat.chanttyai.adapters.ChooseUserAdapter;
import com.imchat.chanttyai.base.BaseFragment;
import com.imchat.chanttyai.beans.UserBean;
import com.imchat.chanttyai.databinding.FragmentChooseBinding;
import com.imchat.chanttyai.ui.activity.ChatActivity;
import com.imchat.chanttyai.utils.SharedPreferUtil;

import java.util.List;
import java.util.stream.Collectors;

public class ChooseFragment extends BaseFragment<FragmentChooseBinding> {

    private ChooseUserAdapter mAdapter;
    private final int mGender;

    public ChooseFragment(int gender) {
        mGender = gender;
    }


    @Override
    protected FragmentChooseBinding getViewBinding(LayoutInflater inflater, ViewGroup container) {
        return FragmentChooseBinding.inflate(getLayoutInflater());
    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initData() {
        initRV();
    }

    private void initRV() {
        mAdapter = new ChooseUserAdapter(new ChooseUserAdapter.OnGotoChatListener() {
            @Override
            public void onClick(UserBean bean) {
                ChatActivity.start(mContext, bean.getAccount());
            }
        });

        filterByGender();

        LinearLayoutManager layoutManager = new LinearLayoutManager(mContext);
        mBinding.rv.setLayoutManager(layoutManager);
        mBinding.rv.setAdapter(mAdapter);
    }

    private void filterByGender() {
        List<UserBean> users = SharedPreferUtil.getInstance().getUsers();
        if (users == null || users.size() == 0){
            return;
        }
        mAdapter.setData(mGender == -1 ? users : users.stream().filter(bean -> bean.getGender() == mGender).collect(Collectors.toList()));
    }

    @Override
    protected void initListener() {

    }
}
