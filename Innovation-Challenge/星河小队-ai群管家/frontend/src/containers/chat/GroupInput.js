import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import WebIM from "@/config/WebIM";
import { I18n } from "react-redux-i18n";
import {
  Button,
  Row,
  Form,
  Input,
  Icon,
  Dropdown,
  Menu,
  message,
  Popover,
  Radio,
  Mentions,
} from "antd";
import { MENTION_ALL } from "@/const/";

const AI_BOT = "ai-bot";

class GroupInput extends React.Component {
  static propTypes = {
    getGroupMember: PropTypes.func,
    handleChange: PropTypes.func,
    handleSend: PropTypes.func,
    setMentionList: PropTypes.func,
  };

  state = {
    prefix: "@",
    value: "",
    callBot: false,
  };

  isAtPrefix = () => {
    return this.state.prefix === "@"
  }
  isBotPrefix = () => {
    return this.state.prefix === "/"
  }

  getOptions = () => {
    if (this.isAtPrefix()) {
      return (
        <>
          <Mentions.Option key={MENTION_ALL} value={MENTION_ALL}>
            {MENTION_ALL}
          </Mentions.Option>
          {this.props.getGroupMember().map((member) => {
            return (
              <Mentions.Option key={member.id} value={`${member.name}`}>
                {member.name}
              </Mentions.Option>
            );
          })}
        </>
      );
    } else if (this.isBotPrefix()) {
      return (
        <Mentions.Option key={AI_BOT} value={AI_BOT}>
          {AI_BOT}
        </Mentions.Option>
      );
    }
  };

  onSearch = (_, newPrefix) => {
    this.setState({
      prefix: newPrefix,
      callBot: false,
    });
  };

  render() {
    return (
      <Mentions
        value={this.props.value}
        onChange={this.props.handleChange}
        onSelect={(e) => {
          if (this.isAtPrefix()) {
            this.props.setMentionList(e);
          } else if (this.isBotPrefix()) {
            this.setState({
              callBot: true
            })
          }
        }}
        onSearch={this.onSearch}
        onKeyPress={(e) => {
          this.props.handleSend(e, this.state.callBot)
          if (e.charCode === 13) {
            this.setState({callBot: false})  
          }
        }}
        placeholder={I18n.t("message")}
        ref={this.props.refInstance}
        prefix={["@", "/"]}
      >
        {this.getOptions()}
      </Mentions>
    );
  }
}
const Component = connect((state, props) => ({
  state: state
}))(GroupInput);

export default React.forwardRef((props, ref) => <Component {...props} refInstance={ref} />)