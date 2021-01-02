import { AppBar, Tab, Tabs } from '@material-ui/core'
import React, { ReactElement } from 'react'

export default function CourseTabs(): ReactElement {
    return (
        <AppBar position="sticky" color="inherit">
          <Tabs value={0} 
      centered>
            <Tab label="HOME" />
            <Tab label="STATISTICS" />
            <Tab label="COURSE" />
          </Tabs>
        </AppBar>
    )
}
