/bin/bash -l -i -c "echo '*** starting Billing-Logic build ***' && \
  source $HOME/.rvm/scripts/rvm && \
  source .rvmrc && \
  bundle exec bundle install && \
  billing && \
  bundle exec rake ci"
