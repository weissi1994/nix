{
  plugins.neo-tree = {
    enable = true;
    sources = ["filesystem" "buffers" "git_status" "document_symbols"];
    filesystem = {
      bindToCwd = false;
      followCurrentFile = { enabled = true; };
      useLibuvFileWatcher = true;
    };
  };
}
