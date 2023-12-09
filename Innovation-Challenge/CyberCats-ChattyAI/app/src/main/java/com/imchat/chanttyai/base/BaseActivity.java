package com.imchat.chanttyai.base;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.viewbinding.ViewBinding;

import com.imchat.chanttyai.utils.StatusBarUtil;

public abstract class BaseActivity<VB extends ViewBinding> extends AppCompatActivity {

    protected BaseActivity<VB> mContext;
    protected VB mBinding;
    protected FragmentManager mFragmentManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        StatusBarUtil.setTranslucentFullScreen(this, null);

        mBinding = getViewBinding();
        setContentView(mBinding.getRoot());
        mContext = this;
        mFragmentManager = getSupportFragmentManager();

        initView();
        initData();
        initListener();

        AppManager.getInstance().addActivity(this);
    }

    public BaseActivity getActivity(){
        return mContext;
    }

    protected abstract VB getViewBinding();

    protected abstract void initView();

    protected abstract void initData();

    protected abstract void initListener();

    @Override
    protected void onDestroy() {
        super.onDestroy();
        AppManager.getInstance().finishActivity(this);
    }
}
