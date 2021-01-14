import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  CircularProgress,
} from "@material-ui/core";
import React, { ReactElement, useEffect } from "react";
import { Trans, useTranslation } from "react-i18next";
import { RouteComponentProps, useLocation, withRouter } from "react-router-dom";
import IndexPage from "..";
import CoursesServer from "../../models/server";
import User from "../../models/user";

type Props = RouteComponentProps;
function useQuery() {
  return new URLSearchParams(useLocation().search);
}

export function AddServerPage(props: Props): ReactElement {
  const query = useQuery();
  const user = User.load();
  const { urls } = user;
  const url = query.get("url");
  const handleClose = () => {
    props.history.push("/");
  };
  if (urls.find((current) => current === url) || !url?.trim()) handleClose();
  const [server, setServer] = React.useState<CoursesServer>(null);
  const getData = async () => {
    setServer(await user.fetchServer(url));
  };
  useEffect(() => {
    getData();
  });
  urls.push(url);
  const { t } = useTranslation("settings");
  return server == null ? (
    <CircularProgress />
  ) : (
    <div>
      <Dialog
        open
        onClose={handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">
          <Trans
            t={t}
            i18nKey="servers.add.title"
            values={{ name: server.name, url: server.url }}
          />
        </DialogTitle>
        <DialogContent>
          <DialogContentText id="alert-dialog-description">
            <Trans
              t={t}
              i18nKey="servers.add.body"
              values={{ name: server.name, url: server.url }}
            />
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose} color="primary">
            {t("servers.add.disagree")}
          </Button>
          <Button
            onClick={() => {
              user.urls = urls;
              user.save();
              handleClose();
            }}
            color="primary"
            autoFocus
          >
            {t("servers.add.agree")}
          </Button>
        </DialogActions>
      </Dialog>
      <IndexPage />
    </div>
  );
}
export default withRouter(AddServerPage);
