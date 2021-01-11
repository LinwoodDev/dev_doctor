import { Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle } from '@material-ui/core'
import React, { ReactElement } from 'react'
import { Trans, useTranslation } from 'react-i18next';
import { RouteComponentProps, useLocation, withRouter } from 'react-router-dom';
import IndexPage from '..'
import CoursesServer from '../../models/server';

interface Props extends RouteComponentProps {   
}
function useQuery() {
  return new URLSearchParams(useLocation().search);
}


export function AddServerPage(props: Props): ReactElement {
    let query = useQuery();
    const handleClose = () => {
        props.history.push('/');
    };
    if(CoursesServer.servers.find((server) => server.url === query.get('url')) || !query.get('url')?.trim())
        handleClose();
    const { t } = useTranslation('settings');
    var servers = CoursesServer.servers;
    var server = new CoursesServer({url: query.get('url'), name: query.get('name')});
    servers.push(server);
    return (
        <div>
        <Dialog
          open={true}
          onClose={handleClose}
          aria-labelledby="alert-dialog-title"
          aria-describedby="alert-dialog-description"
        >
          <DialogTitle id="alert-dialog-title"><Trans t={t} i18nKey="servers.add.title" values={{name: server.name, url: server.url}} /></DialogTitle>
          <DialogContent>
            <DialogContentText id="alert-dialog-description">
            <Trans t={t} i18nKey="servers.add.body" values={{name: server.name, url: server.url}} />
            </DialogContentText>
          </DialogContent>
          <DialogActions>
            <Button onClick={handleClose} color="primary">
              {t('servers.add.disagree')}
            </Button>
            <Button onClick={() => {
                CoursesServer.servers = servers;
                handleClose();
            }} color="primary" autoFocus>
            {t('servers.add.agree')}
            </Button>
          </DialogActions>
        </Dialog>
            <IndexPage />
        </div>
    )
}
export default withRouter(AddServerPage);

