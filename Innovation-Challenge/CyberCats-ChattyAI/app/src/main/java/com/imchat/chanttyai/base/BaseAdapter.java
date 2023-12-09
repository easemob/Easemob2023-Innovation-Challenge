package com.imchat.chanttyai.base;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewbinding.ViewBinding;


import com.imchat.chanttyai.R;
import com.imchat.chanttyai.listeners.OnItemClickListener;

import java.util.List;

public abstract class BaseAdapter<T, VB extends ViewBinding> extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    protected static final int TYPE_NORMAL = 0;
    protected static final int TYPE_NO_MORE = 1;

    private List<T> mList;
    private boolean mWithNoMore;
    private OnItemClickListener<T> mOnItemClickListener;

    public void setData(List<T> list) {
        mList = list;
        notifyDataSetChanged();
    }

    public T getData(int position){
        return mList.get(position);
    }

    public void showNoMore() {
        mWithNoMore = true;
        notifyDataSetChanged();
    }

    public void hideNoMore() {
        mWithNoMore = false;
        notifyDataSetChanged();
    }

    public BaseAdapter() {
    }

    public BaseAdapter(List<T> list) {
        mList = list;
    }

    public BaseAdapter(List<T> list, OnItemClickListener<T> onItemClickListener) {
        mList = list;
        mOnItemClickListener = onItemClickListener;
    }

    public BaseAdapter(OnItemClickListener<T> onItemClickListener) {
        mOnItemClickListener = onItemClickListener;
    }

    public BaseAdapter(boolean withNoMore, OnItemClickListener<T> onItemClickListener) {
        mWithNoMore = withNoMore;
        mOnItemClickListener = onItemClickListener;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == TYPE_NO_MORE) {
            return new NoMoreHolder(LayoutInflater.from(parent.getContext()).inflate(getNoMoreRes(), parent, false));
        }
        return new NormalHolder(getViewBinding(parent));
    }

    protected abstract VB getViewBinding(ViewGroup parent);


    protected int getNoMoreRes() {
        return R.layout.item_no_more;
    }

    @Override
    public int getItemViewType(int position) {
        if (!mWithNoMore) {
            return TYPE_NORMAL;
        }
        if (mList == null || position == mList.size()) {
            return TYPE_NO_MORE;
        }
        return TYPE_NORMAL;
    }

//    protected abstract int getItemRes();

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        if (getItemViewType(position) == TYPE_NO_MORE) {
            return;
        }
        T t = mList.get(position);
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mOnItemClickListener != null)
                    mOnItemClickListener.onItemClick(t, holder.getAdapterPosition());
            }
        });
        bindViewHolder((NormalHolder) holder, t, position);
    }

    protected abstract void bindViewHolder(NormalHolder holder, T bean, int pos);

    @Override
    public int getItemCount() {
        return mList == null ? (mWithNoMore ? 1 : 0) : (mWithNoMore ? mList.size() + 1 : mList.size());
    }


    protected class NormalHolder extends RecyclerView.ViewHolder {
        public VB mBinding;

        public NormalHolder(@NonNull VB itemView) {
            super(itemView.getRoot());
            mBinding = itemView;
        }
    }

    protected class NoMoreHolder extends RecyclerView.ViewHolder {

        public NoMoreHolder(@NonNull View itemView) {
            super(itemView);
        }
    }
}
