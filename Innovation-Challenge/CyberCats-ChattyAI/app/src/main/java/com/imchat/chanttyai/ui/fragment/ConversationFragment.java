package com.imchat.chanttyai.ui.fragment;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.recyclerview.widget.LinearLayoutManager;

import com.hyphenate.chat.EMClient;
import com.hyphenate.chat.EMConversation;
import com.imchat.chanttyai.R;
import com.imchat.chanttyai.adapters.ConversationAdapter;
import com.imchat.chanttyai.base.BaseFragment;
import com.imchat.chanttyai.base.Constants;
import com.imchat.chanttyai.databinding.FragmentConversationBinding;
import com.imchat.chanttyai.listeners.OnItemClickListener;
import com.imchat.chanttyai.livedatas.LiveDataBus;
import com.imchat.chanttyai.ui.activity.ChatActivity;
import com.imchat.chanttyai.utils.DisplayUtil;
import com.imchat.chanttyai.utils.ToastUtils;
import com.imchat.chanttyai.views.dialog.BaseNiceDialog;
import com.imchat.chanttyai.views.dialog.NiceDialog;
import com.imchat.chanttyai.views.dialog.ViewConvertListener;
import com.imchat.chanttyai.views.dialog.ViewHolder;
import com.yanzhenjie.recyclerview.OnItemMenuClickListener;
import com.yanzhenjie.recyclerview.SwipeMenu;
import com.yanzhenjie.recyclerview.SwipeMenuBridge;
import com.yanzhenjie.recyclerview.SwipeMenuCreator;
import com.yanzhenjie.recyclerview.SwipeMenuItem;
import com.yanzhenjie.recyclerview.SwipeRecyclerView;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

public class ConversationFragment extends BaseFragment<FragmentConversationBinding> {

    private ConversationAdapter mAdapter;

    @Override
    protected FragmentConversationBinding getViewBinding(LayoutInflater inflater, ViewGroup container) {
        return FragmentConversationBinding.inflate(getLayoutInflater());
    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initData() {
        initRv();
        loadConversations();
    }

    private void initRv() {
        LinearLayoutManager layoutManager = new LinearLayoutManager(mContext);
        mBinding.rv.setLayoutManager(layoutManager);

        mAdapter = new ConversationAdapter(new OnItemClickListener<Map.Entry<String, EMConversation>>() {
            @Override
            public void onItemClick(Map.Entry<String, EMConversation> map, int pos) {
                ChatActivity.start(mContext,map.getKey());
            }
        });

        mBinding.rv.setSwipeMenuCreator(new SwipeMenuCreator() {
            @Override
            public void onCreateMenu(SwipeMenu leftMenu, SwipeMenu rightMenu, int position) {
                SwipeMenuItem deleteItem = new SwipeMenuItem(mContext);
                deleteItem.setText("删除")
                        .setWidth(DisplayUtil.dp2px(mContext,100))
                        .setHeight(-1)
                        .setTextColor(Color.parseColor("#F9FAFA"))
                        .setBackgroundColor(Color.parseColor("#FF3355"));
                // 各种文字和图标属性设置。
                rightMenu.addMenuItem(deleteItem); // 在Item左侧添加一个菜单。
            }
        });



        mBinding.rv.setOnItemMenuClickListener(new OnItemMenuClickListener() {
            @Override
            public void onItemClick(SwipeMenuBridge menuBridge, int position) {
                // 任何操作必须先关闭菜单，否则可能出现Item菜单打开状态错乱。
                menuBridge.closeMenu();

                // 左侧还是右侧菜单：
                int direction = menuBridge.getDirection();
                // 菜单在Item中的Position：
                int menuPosition = menuBridge.getPosition();

                if (direction == SwipeRecyclerView.RIGHT_DIRECTION && menuPosition == 0) {
                    delete(position);
                }
            }
        });

        mBinding.rv.setAdapter(mAdapter);
    }

    private void delete(int position) {
        NiceDialog.init().setLayoutId(R.layout.dialog_layout)
                .setConvertListener(new ViewConvertListener() {
                    @Override
                    protected void convertView(ViewHolder holder, BaseNiceDialog dialog) {

                        holder.getView(R.id.btn_confirm).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                Map.Entry<String, EMConversation> map = mAdapter.getData(position);
                                EMClient.getInstance().chatManager().deleteConversation(map.getKey(), true);
                                loadConversations();
                                ToastUtils.toast("已删除");
                                dialog.dismissAllowingStateLoss();
                            }
                        });
                        holder.getView(R.id.btn_cancel).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                dialog.dismissAllowingStateLoss();
                            }
                        });
                    }
                })
                .setMargin(DisplayUtil.dp2px(mContext, 10))
                .setOutCancel(false)
                .show(mFragmentManager);
    }

    private void loadConversations() {
        Map<String, EMConversation> allConversations = EMClient.getInstance().chatManager().getAllConversations();
        boolean none = allConversations.isEmpty();
        if (noneData(none)){
            return;
        }
        List<Map.Entry<String, EMConversation>> list = new ArrayList<>(allConversations.entrySet());
        sort(list);
        mAdapter.setData(list);
    }

    private void sort(List<Map.Entry<String, EMConversation>> list) {
        Collections.sort(list, (m1, m2) -> (int) (m2.getValue().getLastMessage().getMsgTime() - m1.getValue().getLastMessage().getMsgTime()));
    }

    private boolean noneData(boolean none){
        mBinding.rv.setVisibility(none?View.GONE:View.VISIBLE);
        mBinding.ivNone.setVisibility(none?View.VISIBLE:View.GONE);
        return none;
    }

    @Override
    protected void initListener() {
        LiveDataBus.get().with(Constants.MSG_RECEIVED,String.class).observe(this,this::onMsgReceive);
        LiveDataBus.get().with(Constants.MSG_READ).observe(this,this::onMsgRead);
    }

    private void onMsgRead(Object o) {
        loadConversations();
    }

    private void onMsgReceive(String nul) {
        loadConversations();
    }
}
