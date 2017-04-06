module RequestSpecHelper
  # Parse JSON response to ruby hash

  def json
    JSON.parse(response.body)    # ??? de donde sale este response
  end
end
