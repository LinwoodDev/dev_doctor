import React, { ReactElement, useEffect, useState } from "react";
import {
  ColDef,
  DataGrid,
  RowModel,
  RowsProp,
  SelectionChangeParams,
} from "@material-ui/data-grid";
import { Button } from "@material-ui/core";
import { SettingsProps } from "./route";

export default function ServersSettingsPage({
  user,
}: SettingsProps): ReactElement {
  const columns: ColDef[] = [
    { field: "serverURL", headerName: "URL", width: 300 },
    { field: "serverName", headerName: "Name", width: 130 },
  ];
  const [items, setItems] = useState(null);
  const rows: RowsProp = [];
  const getData = async () => {
    (await user.fetchServers()).forEach((server, index) => {
      rows.push({
        id: index,
        serverName: server.name,
        serverURL: server.url,
      } as RowModel);
    });
    setItems(rows);
  };
  useEffect(() => {
    getData();
  });
  const [deletedRows, setDeletedRows] = useState([]);
  const handleRowSelection = (param: SelectionChangeParams) => {
    console.log(param.rowIds);
    setDeletedRows([
      ...deletedRows,
      ...rows.filter((r) => param.rowIds.includes(String(r.id))),
    ]);
  };
  const handlePurge = () => {
    setItems(
      rows.filter((r) => deletedRows.filter((sr) => sr.id === r.id).length < 1)
    );
    user.urls = user.urls.filter((value, index) =>
      items.map((item) => item.id).includes(index)
    );
  };
  console.log(user.urls);
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
