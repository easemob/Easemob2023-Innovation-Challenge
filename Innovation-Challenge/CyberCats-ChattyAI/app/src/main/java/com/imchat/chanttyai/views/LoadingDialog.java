package com.imchat.chanttyai.views;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import androidx.fragment.app.FragmentManager;

import com.imchat.chanttyai.R;
import com.imchat.chanttyai.utils.DisplayUtil;
import com.imchat.chanttyai.views.dialog.BaseNiceDialog;
import com.imchat.chanttyai.views.dialog.NiceDialog;
import com.imchat.chanttyai.views.dialog.ViewConvertListener;
import com.imchat.chanttyai.views.dialog.ViewHolder;

public class LoadingDialog {

    public static LoadingDialog getInstance(){
        if (loadingDialog == null){
            loadingDialog = new LoadingDialog();
        }
        return loadingDialog;
    }
    private static LoadingDialog loadingDialog;

    private LoadingDialog(){

    }
    private BaseNiceDialog dialog;

    public void show(Context context, FragmentManager manager, String content){
        dialog = NiceDialog.init().setLayoutId(R.layout.dialog_login)
                .setConvertListener(new ViewConvertListener() {
                    @Override
                    protected void convertView(ViewHolder holder, BaseNiceDialog dialog) {
                        TextView tvContent = (TextView) holder.getView(R.id.tv_content);
                        tvContent.setVisibility(View.VISIBLE);
                        tvContent.setText(content);
                    }
                })
                .setWidth(DisplayUtil.dp2px(context, 100))
                .setOutCancel(false);

        dialog.show(manager);
    }

    public void show(Context context, FragmentManager manager){
        dialog = NiceDialog.init().setLayoutId(R.layout.dialog_login)
                .setWidth(DisplayUtil.dp2px(context, 100))
                .setOutCancel(false);
        dialog.show(manager);
    }

    public void dismiss(){
        if (dialog != null){
            dialog.dismissAllowingStateLoss();
        }
    }
}
