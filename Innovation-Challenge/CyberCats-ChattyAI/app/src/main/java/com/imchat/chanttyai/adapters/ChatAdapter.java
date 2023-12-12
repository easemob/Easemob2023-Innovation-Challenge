package com.imchat.chanttyai.adapters;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMMessageBody;
import com.hyphenate.chat.EMTextMessageBody;
import com.imchat.chanttyai.R;
import com.imchat.chanttyai.base.Constants;
import com.imchat.chanttyai.beans.UserBean;
import com.imchat.chanttyai.utils.DateUtils;
import com.imchat.chanttyai.utils.SharedPreferUtil;

import java.util.List;

public class ChatAdapter extends RecyclerView.Adapter<ChatAdapter.MsgHolder> {

    protected static final int TYPE_LEFT = 0;
    protected static final int TYPE_RIGHT = 1;
    private List<EMMessage> mList;


    public void setData(List<EMMessage> list){
        mList = list;
        notifyDataSetChanged();
    }
    @NonNull
    @Override
    public ChatAdapter.MsgHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == TYPE_LEFT){
            return new MsgHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_chat_left, parent, false));
        }
        return new MsgHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_chat_right, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull ChatAdapter.MsgHolder holder, int position) {
        EMMessage currentMessage = mList.get(position);
        EMMessageBody body = currentMessage.getBody();
        if (body instanceof EMTextMessageBody){
            holder.mTvContent.setText(((EMTextMessageBody) body).getMessage());

            String account = currentMessage.getFrom();
            if (!TextUtils.equals(account,SharedPreferUtil.getInstance().getAccount())){
                UserBean userBean = SharedPreferUtil.getInstance().getUserByAccount(account);
                if (userBean != null && userBean.getGender() != null){
                    holder.mTvContent.setBackgroundResource(userBean.getGender() == Constants.GENDER_MALE?
                            R.drawable.sp_msg_left_male:R.drawable.sp_msg_left_female);
                }
            }
        }
        long currentTime = mList.get(position).getMsgTime();
        String timeStr = DateUtils.formatTimestamp(currentTime,true);
        holder.mTvTime.setText(timeStr);

//        if (position >0){
//            long preTime = mList.get(position - 1).getMsgTime();
//            if (currentTime - preTime > 10 * 60 * 1000){
//                holder.mTvTime.setVisibility(View.VISIBLE);
//                holder.mTvTime.setText(timeStr);
//            }else {
//                holder.mTvTime.setVisibility(View.GONE);
//            }
//        }else {
//            holder.mTvTime.setVisibility(View.VISIBLE);
//            holder.mTvTime.setText(timeStr);
//        }
    }

    @Override
    public int getItemCount() {
        return mList == null ? 0 : mList.size();
    }

    @Override
    public int getItemViewType(int position) {
        EMMessage message = mList.get(position);
        if (TextUtils.equals(message.getFrom(), SharedPreferUtil.getInstance().getAccount())) {
            return TYPE_RIGHT;
        }
        return TYPE_LEFT;
    }

    protected static class MsgHolder extends RecyclerView.ViewHolder {

        protected TextView mTvContent;
        protected TextView mTvTime;
        public MsgHolder(@NonNull View itemView) {
            super(itemView);
            mTvContent = itemView.findViewById(R.id.tv_content);
            mTvTime = itemView.findViewById(R.id.tv_time);
        }
    }
}
