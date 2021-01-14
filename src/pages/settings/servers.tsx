import React, { ReactElement, useState } from "react";
import { SettingsProps } from "./route";
import {
  ColDef,
  DataGrid,
  RowModel,
  RowsProp,
  SelectionChangeParams,
} from "@material-ui/data-grid";
import { Button } from "@material-ui/core";

export default function ServersSettingsPage({
  user,
}: SettingsProps): ReactElement {
  const columns: ColDef[] = [
    { field: "serverURL", headerName: "URL", width: 300 },
    { field: "serverName", headerName: "Name", width: 130 },
  ];
  const rows: RowsProp = [];
  user.servers.forEach((server, index) => {
    rows.push({
      id: index,
      serverName: server.name,
      serverURL: server.url,
    } as RowModel);
  });
  const [items, setItems] = useState(rows);
  const [deletedRows, setDeletedRows] = useState([]);
  const handleRowSelection = (param : SelectionChangeParams) => {
      console.log(param.rowIds);
   setDeletedRows([...deletedRows, ...rows.filter((r) => param.rowIds.includes(String(r.id)))]);
 };
  const handlePurge = () => {
    setItems(
      rows.filter((r) => deletedRows.filter((sr) => sr.id === r.id).length < 1)
    );
    user.servers = user.servers.filter((value, index) => items.map((item) => item.id).includes(index));
  };
  console.log(user.servers);
  return (
      <>
    <div style={{ height: 400, width: "100%" }}>
      <DataGrid
        onSelectionChange={handleRowSelection}
        rows={items}
        columns={columns}
        pageSize={10}
        
        checkboxSelection
      />
    </div>
      <Button variant="contained" color="primary" onClick={handlePurge}>
        Purge
      </Button>
    </>
  );
}
