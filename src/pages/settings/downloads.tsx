import { Typography } from "@material-ui/core";
import React, { ReactElement } from "react";
import { useTranslation } from "react-i18next/*";
import { SettingsProps } from "./route";

export default function DownloadsSettingsPage(
  props: SettingsProps
): ReactElement {
    const {t} = useTranslation(['settings', 'common']);
  return (
    <div>
      <Typography>{t("common:coming-soon")}</Typography>
    </div>
  );
}
