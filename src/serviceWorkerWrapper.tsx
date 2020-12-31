import React, { FC, useEffect } from 'react';
import { Snackbar, Button } from '@material-ui/core';
import * as serviceWorkerRegistration from './serviceWorkerRegistration';
import { useSnackbar } from 'notistack';

const ServiceWorkerWrapper: FC = () => {
  const { enqueueSnackbar } = useSnackbar();
  const [showReload, setShowReload] = React.useState(false);
  const [waitingWorker, setWaitingWorker] = React.useState<ServiceWorker | null>(null);

  const onSWUpdate = (registration: ServiceWorkerRegistration) => {
    setShowReload(true);
    setWaitingWorker(registration.waiting);
  };
  const onSWSuccess = (registration: ServiceWorkerRegistration) => {
    enqueueSnackbar('Ready for offline use.');
  };

  useEffect(() => {
    serviceWorkerRegistration.register({ onUpdate: onSWUpdate, onSuccess: onSWSuccess });
  });

  const reloadPage = () => {
    waitingWorker?.postMessage({ type: 'SKIP_WAITING' });
    setShowReload(false);
    window.location.reload();
  };

  return (
    <Snackbar
      open={showReload}
      message="A new version is available!"
      onClick={reloadPage}
      anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      action={
        <Button
          color="inherit"
          size="small"
          onClick={reloadPage}
        >
          Reload
        </Button>
      }
    />
  );
}

export default ServiceWorkerWrapper;