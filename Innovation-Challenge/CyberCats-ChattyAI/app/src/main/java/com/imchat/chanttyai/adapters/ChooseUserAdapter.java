package com.imchat.chanttyai.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.imchat.chanttyai.R;
import com.imchat.chanttyai.base.BaseAdapter;
import com.imchat.chanttyai.base.Constants;
import com.imchat.chanttyai.beans.UserBean;
import com.imchat.chanttyai.databinding.ItemChooseAdapterBinding;
import com.imchat.chanttyai.listeners.OnItemClickListener;
import com.imchat.chanttyai.utils.UserUtil;

public class ChooseUserAdapter extends BaseAdapter<UserBean, ItemChooseAdapterBinding> {
    private final OnGotoChatListener mOnGotoChatListener;

    public ChooseUserAdapter(OnGotoChatListener onGotoChatListener) {
        mOnGotoChatListener = onGotoChatListener;
    }

    @Override
    protected ItemChooseAdapterBinding getViewBinding(ViewGroup parent) {
        return ItemChooseAdapterBinding.inflate(LayoutInflater.from(parent.getContext()), parent, false);
    }

    @Override
    protected void bindViewHolder(BaseAdapter<UserBean, ItemChooseAdapterBinding>.NormalHolder holder, UserBean bean, int pos) {
        holder.mBinding.tvName.setText(bean.getName());
        holder.mBinding.tvDesc.setText(bean.getDesc());

        int avatarRes = UserUtil.getInstance().getAvatarRes(bean.getAccount());
        if (avatarRes != -1){
            holder.mBinding.ivAvatar.setImageResource(avatarRes);
        }

        holder.mBinding.btnChat.setBackgroundResource(bean.getGender() == Constants.GENDER_MALE? R.drawable.sp_btn:R.drawable.sp_btn_female);
        holder.mBinding.btnChat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mOnGotoChatListener.onClick(bean);
            }
        });
    }

    public interface OnGotoChatListener{
        void onClick(UserBean bean);
    }
}
