FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /ordering-system
COPY Gemfile /ordering-system/Gemfile
COPY Gemfile.lock /ordering-system/Gemfile.lock
RUN bundle install
COPY . /ordering-system

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3002

# Configure the main process to run when running the image.
CMD ["rails", "server", "-b", "0.0.0.0"]