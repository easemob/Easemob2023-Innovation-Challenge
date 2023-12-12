package com.imchat.chanttyai.ui.activity;

import android.content.Context;
import android.content.Intent;
import android.graphics.Rect;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.inputmethod.EditorInfo;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
import com.hyphenate.chat.EMMessage;
import com.imchat.chanttyai.R;
import com.imchat.chanttyai.adapters.ChatAdapter;
import com.imchat.chanttyai.base.AppManager;
import com.imchat.chanttyai.base.BaseActivity;
import com.imchat.chanttyai.base.Constants;
import com.imchat.chanttyai.beans.UserBean;
import com.imchat.chanttyai.databinding.ActivityChatBinding;
import com.imchat.chanttyai.livedatas.LiveDataBus;
import com.imchat.chanttyai.utils.SharedPreferUtil;
import com.imchat.chanttyai.utils.UserUtil;

import java.util.List;

public class ChatActivity extends BaseActivity<ActivityChatBinding> implements View.OnClickListener {

    private String mChatTo;
    private ChatAdapter mAdapter;
    private LinearLayoutManager mLayoutManager;

    public static void start(Context context, String chatTo) {
        Intent intent = new Intent(context, ChatActivity.class);
        intent.putExtra(Constants.KEY_CHAT_TO, chatTo);
        context.startActivity(intent);
    }

    @Override
    protected ActivityChatBinding getViewBinding() {
        return ActivityChatBinding.inflate(getLayoutInflater());
    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initData() {
        mChatTo = getIntent().getStringExtra(Constants.KEY_CHAT_TO);

        initBg();

        initRv();

        loadMsgs();
    }

    private void initBg() {
        int bgRes = UserUtil.getInstance().getBgRes(mChatTo);
        if (bgRes != -1){
            mBinding.ivBg.setImageResource(bgRes);
        }

        UserBean bean = SharedPreferUtil.getInstance().getUserByAccount(mChatTo);
        if (bean != null){
            mBinding.tvName.setText(bean.getName());
        }
    }

    private void loadMsgs() {
        EMConversation conversation = EMClient.getInstance().chatManager().getConversation(mChatTo);
        //List<EMMessage> messages = conversation.getAllMessages();

        if (conversation == null){
            return;
        }
        conversation.markAllMessagesAsRead();
        LiveDataBus.get().with(Constants.MSG_READ).postValue("");
        // startMsgId：查询的起始消息 ID。SDK 从该消息 ID 开始按消息时间戳的逆序加载。如果传入消息的 ID 为空，SDK 从最新消息开始按消息时间戳的逆序获取。
        // pageSize：每页期望加载的消息数。取值范围为 [1,400]。
        List<EMMessage> messages = conversation.loadMoreMsgFromDB("", 999);
        mAdapter.setData(messages);

        scroll2Last();
    }

    private void scroll2Last(){
        int count = mAdapter.getItemCount()-1;
        mBinding.rv.post(new Runnable() {
            @Override
            public void run() {
                mBinding.rv.scrollToPosition(count);
            }
        });
    }

    private void initRv() {
        mLayoutManager = new LinearLayoutManager(mContext);

        mAdapter = new ChatAdapter();
        mBinding.rv.setLayoutManager(mLayoutManager);
        mBinding.rv.setAdapter(mAdapter);

    }

    @Override
    protected void initListener() {
        mBinding.btnSend.setOnClickListener(this);
        mBinding.ivBack.setOnClickListener(this);
        mBinding.etContent.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                String content = mBinding.etContent.getText().toString().trim();
                mBinding.btnSend.setVisibility(TextUtils.isEmpty(content)?View.GONE:View.VISIBLE);
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        //回车发送
//        mBinding.etContent.setOnEditorActionListener(new TextView.OnEditorActionListener() {
//            @Override
//            public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
//                if (actionId == EditorInfo.IME_ACTION_SEND ||
//                        (keyEvent != null && keyEvent.getKeyCode() == KeyEvent.KEYCODE_ENTER &&
//                                keyEvent.getAction() == KeyEvent.ACTION_DOWN)) {
//                    // 在这里执行发送操作
//                    sendMsg();
//                    return true;
//                }
//                return false;
//            }
//        });

        LiveDataBus.get().with(Constants.MSG_RECEIVED, String.class).observe(this,this::onMsgReceived);

        setKeyboardListener();
    }

    private void setKeyboardListener() {
        // 获取根布局的View实例
        View rootView = findViewById(android.R.id.content);

        // 获取根布局的ViewTreeObserver
        ViewTreeObserver viewTreeObserver = rootView.getViewTreeObserver();

        // 添加布局变化监听器
        viewTreeObserver.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                // 获取根布局可见区域的矩形
                Rect r = new Rect();
                rootView.getWindowVisibleDisplayFrame(r);

                // 计算屏幕高度和可见区域的差值
                int screenHeight = rootView.getRootView().getHeight();
                int heightDiff = screenHeight - (r.bottom - r.top);

                // 判断键盘是否可见
                boolean isKeyboardVisible = heightDiff > screenHeight * 0.15; // 可根据实际情况调整阈值

                // 处理键盘的弹出和隐藏事件
                if (isKeyboardVisible) {
                    // 键盘弹出
                    // 在这里添加您的处理逻辑，例如滚动RecyclerView到最后一项
                    scroll2Last();
                }
            }
        });
    }

    private void onMsgReceived(String nul) {
        loadMsgs();
    }

    private void sendMsg() {
        String content = mBinding.etContent.getText().toString();
        EMMessage message = EMMessage.createTextSendMessage(content, mChatTo);
        // 发送消息
        EMClient.getInstance().chatManager().sendMessage(message);
        mBinding.etContent.setText("");

        loadMsgs();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btn_send){
            sendMsg();
            return;
        }

        if (id == R.id.iv_back){
            AppManager.getInstance().finishActivity(this);
        }
    }
}
