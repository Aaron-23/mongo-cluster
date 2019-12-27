rs.initiate();
cfg = {
  _id: 'rainbond',
  members: [
    { _id: 3, host: '127.0.0.1:27017' },
    { _id: 2, host: '127.0.0.1:27018' },
    { _id: 1, host: '127.0.0.1:27019' }
  ]
};
cfg.protocolVersion = 1;
rs.reconfig(cfg, { force: true });