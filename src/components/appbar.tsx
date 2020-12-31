import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import { useTranslation } from "react-i18next";
import LanguageOutlinedIcon from '@material-ui/icons/LanguageOutlined';
import AccountCircleOutlinedIcon from '@material-ui/icons/AccountCircleOutlined';
import TuneOutlinedIcon from '@material-ui/icons/TuneOutlined';
import SettingsOutlinedIcon from '@material-ui/icons/SettingsOutlined';
import InfoOutlinedIcon from '@material-ui/icons/InfoOutlined';
import StarsOutlinedIcon from '@material-ui/icons/StarsOutlined';
import {
    AppBar,
    IconButton,
    ListItemIcon,
    ListItemText,
    Menu,
    MenuItem,
    Toolbar,
    Typography,
} from "@material-ui/core";

const useStyles = makeStyles((theme) => ({
    root: {
        flexGrow: 1,
    },
    menuButton: {
        marginRight: theme.spacing(2),
    },
    title: {
        flexGrow: 1,
    },
}));
interface MyAppBarProps{
    title: string;
}
export default function MyAppBar(props : MyAppBarProps) {
    const { t, i18n } = useTranslation('common');
    const [languageAnchorEl, setLanguageAnchorEl] = React.useState(null);
    const [accountAnchorEl, setAccountAnchorEl] = React.useState(null);

    const handleLanguageClick = (event: { currentTarget: any }) => {
        setLanguageAnchorEl(event.currentTarget);
    };

    const handleLanguageClose = () => {
        setLanguageAnchorEl(null);
    };
    const handleAccountClick = (event: { currentTarget: any }) => {
        setAccountAnchorEl(event.currentTarget);
    };
    const changeLanguage = (lng: string) => {
        i18n.changeLanguage(lng);
        handleLanguageClose();
    };

    const handleAccountClose = () => {
        setAccountAnchorEl(null);
    };

    const classes = useStyles();
    return (
        <AppBar position="static">
            <Toolbar>
                <IconButton
                    edge="start"
                    className={classes.menuButton}
                    color="inherit"
                    aria-label="menu"
                    href="/"
                >
                    <img width="32" src="/assets/logo-dark.png" alt="logo" />
                </IconButton>
                <Typography variant="h6" className={classes.title}>
                    {props.title}
                </Typography>
                <IconButton
                    aria-controls="language-menu"
                    aria-haspopup="true"
                    onClick={handleLanguageClick}
                >
                    <LanguageOutlinedIcon />
                </IconButton>
                <Menu
                    id="language-menu"
                    anchorEl={languageAnchorEl}
                    keepMounted
                    open={Boolean(languageAnchorEl)}
                    onClose={handleLanguageClose}
                >
                    {i18n.languages.map((e) => (
                        <MenuItem key={e} onClick={() => changeLanguage(e)} selected={e === i18n.language}>
                            {t("language." + e)}
                        </MenuItem>
                    ))}
                </Menu>
                <IconButton
                    aria-controls="account-menu"
                    aria-haspopup="true"
                    onClick={handleAccountClick}
                >
                    <AccountCircleOutlinedIcon />
                </IconButton>
                <Menu
                    id="account-menu"
                    anchorEl={accountAnchorEl}
                    keepMounted
                    open={Boolean(accountAnchorEl)}
                    onClose={handleAccountClose}
                >
                    <MenuItem>
                        <ListItemIcon>
                            <TuneOutlinedIcon fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary={t('profile')} />
                    </MenuItem>
                    <MenuItem>
                        <ListItemIcon>
                            <StarsOutlinedIcon fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary={t('badges')} />
                    </MenuItem>
                    <MenuItem>
                        <ListItemIcon>
                            <SettingsOutlinedIcon fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary={t('settings')} />
                    </MenuItem>
                    <MenuItem>
                        <ListItemIcon>
                            <InfoOutlinedIcon fontSize="small" />
                        </ListItemIcon>
                        <ListItemText primary={t('info')} />
                    </MenuItem>
                </Menu>
            </Toolbar>
        </AppBar>
    );
}
