import { TextField } from '@material-ui/core';
import React, { ReactElement } from 'react'
import { useTranslation } from 'react-i18next';
import { SettingsProps } from './route'


export default function SettingsHomePage({user}: SettingsProps): ReactElement {
    const {t} = useTranslation('settings');
    return (
        <>
            <TextField label={t('home.username')} defaultValue={user.name} onChange={(event) => user.name = event.target.value} />
        </>
    )
}
