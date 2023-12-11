package com.imchat.chanttyai.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMMessage;
import com.hyphenate.chat.EMMessageBody;
import com.hyphenate.chat.EMTextMessageBody;
import com.imchat.chanttyai.R;
import com.imchat.chanttyai.base.BaseAdapter;
import com.imchat.chanttyai.base.Constants;
import com.imchat.chanttyai.beans.UserBean;
import com.imchat.chanttyai.databinding.ItemConversationBinding;
import com.imchat.chanttyai.listeners.OnItemClickListener;
import com.imchat.chanttyai.utils.DateUtils;
import com.imchat.chanttyai.utils.SharedPreferUtil;
import com.imchat.chanttyai.utils.UserUtil;

import java.util.Map;

public class ConversationAdapter extends BaseAdapter<Map.Entry<String, EMConversation>, ItemConversationBinding> {
    public ConversationAdapter(OnItemClickListener<Map.Entry<String, EMConversation>> onItemClickListener) {
        super(onItemClickListener);
    }

    @Override
    protected ItemConversationBinding getViewBinding(ViewGroup parent) {
        return ItemConversationBinding.inflate(LayoutInflater.from(parent.getContext()), parent, false);
    }

    @Override
    protected void bindViewHolder(BaseAdapter<Map.Entry<String, EMConversation>, ItemConversationBinding>.NormalHolder holder, Map.Entry<String, EMConversation> map, int pos) {
        EMConversation conversation = map.getValue();
        String account = conversation.conversationId();

        UserBean userBean = SharedPreferUtil.getInstance().getUserByAccount(account);

        holder.mBinding.tvName.setText(userBean.getName());
        EMMessage lastMessage = conversation.getLastMessage();
        EMMessageBody body = lastMessage.getBody();
        if (body instanceof EMTextMessageBody){
            holder.mBinding.tvContent.setText(((EMTextMessageBody) body).getMessage());
        }

        if (conversation.getUnreadMsgCount()>0){
            holder.mBinding.tvUnread.setVisibility(View.VISIBLE);
            holder.mBinding.tvUnread.setBackgroundResource(userBean.getGender() == Constants.GENDER_MALE?
                    R.drawable.sp_unread :R.drawable.sp_unread_female);
        }else {
            holder.mBinding.tvUnread.setVisibility(View.GONE);
        }
        holder.mBinding.tvUnread.setVisibility(conversation.getUnreadMsgCount()>0? View.VISIBLE:View.INVISIBLE);

        holder.mBinding.tvTime.setText(DateUtils.formatTimestamp(lastMessage.getMsgTime(),true));

        int avatarRes = UserUtil.getInstance().getAvatarRes(account);
        if (avatarRes != -1){
            holder.mBinding.ivAvatar.setImageResource(avatarRes);
        }
    }
}
