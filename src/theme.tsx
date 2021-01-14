import { orange, purple } from '@material-ui/core/colors';
import { createMuiTheme } from '@material-ui/core/styles';

const theme = createMuiTheme({      
  typography: {
    button: {
      textTransform: 'none'
    }
  },
  palette: {
      primary: orange,
      secondary: purple
  }
});

export default theme;