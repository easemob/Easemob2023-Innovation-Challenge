import React from "react";
import { connect } from "react-redux";
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
import { COMMAND_LIST } from "@/const/"

class ChatInput extends React.Component {

  constructor() {
    super()
    this.state = {
      prefix: "/",
      callBot: false
    }
    this.onSearch = this.onSearch.bind(this)
    this.getOptions = this.getOptions.bind(this)
  }

  onSearch = (_, newPrefix) => {
    console.log("newPrefix ", newPrefix)
    this.setState({
      prefix: newPrefix,
      callBot: false,
    });
  };

  getOptions = () => {
    return (
      <>{
        COMMAND_LIST.filter((cmd) => cmd.isGroup === false)
        .map((command) => {
          return (
            <Mentions.Option key={command.name} value={command.name}>
              {command.name}
            </Mentions.Option>
          )
        })
      }</>
    )
  }

  render() {
    return (
      <Mentions
        value={this.props.value}
        onChange={this.props.handleChange}
        onSelect={(e) => {
          if (this.state.prefix === "/") {
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
        prefix={["/"]}
      >
        {this.getOptions()}
      </Mentions>
    );
  }
}

const Component = connect((state, props) => ({
  state: state
}))(ChatInput);

export default React.forwardRef((props, ref) => <Component {...props}  refInstance={ref}/>)
