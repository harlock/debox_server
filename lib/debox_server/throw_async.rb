# Async response for Thin and other EventMachine servers
# Inspired on this post: http://polycrystal.org/2012/04/15/asynchronous_responses_in_rack.html
module ThrowAsync

  def chunk(content)
    body.push content
  end

  def close
    @before_close_callback.call if @before_close_callback
    # calls Thin's callback which closes the request
    body.succeed
  end

  def on_error(&block)
    body.errback block
  end

  def on_success(&block)
    body.callback block
  end

  def before_close(&block)
    @before_close_callback = block
  end

  def after_close(&block)
    on_error block
    on_success block
  end

  def async(&block)
    # Send the reply headers
    env['async.callback'].call [200, {'Content-Type' => 'text/plain'}, body]

    # Call the given block
    block.call
    throw :async
  end

  private

  # A deferrable object for the body.
  class DeferrableBody
    include EventMachine::Deferrable

    def push(content)
      @body_callback.call content
    end

    def each(&blok)
      @body_callback = blok
    end
  end


  def body
    @deferable_body ||= DeferrableBody.new
  end

end
