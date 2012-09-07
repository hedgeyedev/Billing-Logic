/bin/bash -l -i -c "echo '*** starting Billing-Logic build ***' && \
  bundle exec bundle install && \
  billing && \
  source $HOME/.rvm/scripts/rvm && \
  source .rvmrc && \
  bundle exec rake ci"
