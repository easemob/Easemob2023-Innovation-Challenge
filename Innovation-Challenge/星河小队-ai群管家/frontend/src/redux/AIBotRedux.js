import { createReducer, createActions } from "reduxsauce";
import Immutable from "seamless-immutable";
import _ from "lodash";
import WebIM from "@/config/WebIM";
import { PromptList } from "@/config/api";
import { I18n } from "react-redux-i18n";

import CommonActions from "@/redux/CommonRedux";

/* ------------- Types and Action Creators ------------- */
const { Types, Creators } = createActions({
  updateRoleList: ['roleList'],
  selectRole: ['role'],
  // ----------------async------------------
  getSupportRoles: () => {
    return (dispatch, getState) => {
      dispatch(CommonActions.fetching());
      return PromptList()
        .then((d) => {
          dispatch(Creators.updateRoleList(d));
          return d;
        })
        .finally(() => {
          dispatch(CommonActions.fetched());
        });
    };
  },
  setRole: (role) => {
    return (dispatch, getState) => {
      dispatch(Creators.selectRole(role))
    }
  }
});

export default Creators;

/* ------------- Initial State ------------- */
export const INITIAL_STATE = Immutable({
  roleList: [],
  selectedRole: null,
});

export const updateRoleList = (state, { roleList }) => {
  return state.merge({
    roleList,
  });
};

export const selectRole = (state, {role}) => {
  const roleList = state.getIn(['roleList'], Immutable([]))
  if (roleList.find((item) => item.id === role) === null) {
    return state
  }
  return state.merge({
    selectedRole: role
  })
}

/* ------------- Hookup Reducers To Types ------------- */
export const reducer = createReducer(INITIAL_STATE, {
  [Types.UPDATE_ROLE_LIST]: updateRoleList,
  [Types.SELECT_ROLE]: selectRole,
});

/* ------------- Selectors ------------- */
