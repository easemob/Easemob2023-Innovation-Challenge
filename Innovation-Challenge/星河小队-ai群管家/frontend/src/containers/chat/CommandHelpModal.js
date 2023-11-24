import React from "react";
import { connect } from "react-redux";
import { COMMAND_LIST } from "@/const/"


class CommandHelpModal extends React.Component {
  render() {
    return (
      <div>
        <p>
          通过输入
          <span style={{fontStyle:"italic"}}>
            {this.props.isGroup && ("/ai-bot <cmd>")}
            {!this.props.isGroup && ("/<cmd>")}
          </span>
          触发命令
        </p>
        {COMMAND_LIST.filter(
          (cmd) => cmd.isGroup === (this.props.isGroup || false)
        ).map((command) => {
          return (
            <p key={command.name}>
              <span style={{ fontWeight: "bold" }}>{command.name}</span>:{" "}
              {command.desc}
            </p>
          );
        })}
      </div>
    );
  }
}

export default connect()(CommandHelpModal);
