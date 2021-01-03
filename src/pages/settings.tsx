import React, { ReactElement } from 'react'
import { useTranslation } from "react-i18next";
import MyAppBar from '../components/appbar'

export default function SettingsPage(): ReactElement {
    const {t} = useTranslation("settings")
    return (
        <>
            <MyAppBar title={t("settings")} />
            
        </>
    )
}
