import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import MenuIcon from '@material-ui/icons/Menu';
import { useTranslation } from 'react-i18next';
import { AppBar, Button, IconButton, Menu, MenuItem, Toolbar, Typography } from '@material-ui/core';

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

export default function MyAppBar() {
    const { i18n } = useTranslation();
    const [anchorEl, setAnchorEl] = React.useState(null);
  
    const handleClick = (event: { currentTarget: any; }) => {
      setAnchorEl(event.currentTarget);
    };
  
    const handleClose = () => {
      setAnchorEl(null);
    };
  
    const changeLanguage = (lng: string) => {
      i18n.changeLanguage(lng);
      handleClose();
    }
    const classes = useStyles();
    return (
        <AppBar position="static">
            <Toolbar>
                <IconButton edge="start" className={classes.menuButton} color="inherit" aria-label="menu">
                    <MenuIcon />
                </IconButton>
                <Typography variant="h6" className={classes.title}>
                    News
                </Typography>
                <Button aria-controls="language-menu" aria-haspopup="true" onClick={handleClick}>
  LANGUAGE
</Button>
<Menu
  id="language-menu"
  anchorEl={anchorEl}
  keepMounted
  open={Boolean(anchorEl)}
  onClose={handleClose}
>
  <MenuItem onClick={() => changeLanguage('de')}>Deutsch</MenuItem>
  <MenuItem onClick={() => changeLanguage('en')}>English</MenuItem>
</Menu>
            </Toolbar>
        </AppBar>
    )
}
