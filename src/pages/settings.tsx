import React, { ReactElement } from 'react'
import { useTranslation } from "react-i18next";
import MyAppBar from '../components/appbar'

interface Props {
    
}

export default function SettingsPage({}: Props): ReactElement {
    const {t} = useTranslation("settings")
    return (
        <>
            <MyAppBar title={t("settings")} />
            
        </>
    )
}
