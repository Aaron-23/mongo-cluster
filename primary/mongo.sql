rs.initiate();
cfg = {
  _id: 'rainbond',
  members: [
    { _id: 1, host: 'HOSTNAME:POD_IP' },
    { _id: 2, host: 'HOSTNAME:POD_IP' },
    { _id: 3, host: 'HOSTNAME:POD_IP' }
  ]
};
cfg.protocolVersion = 1;
rs.reconfig(cfg, { force: true });