class JSONTableViewController < UITableViewController
  def initWithHighscore(mode)
    init
    self.title = mode
    @mode = mode.downcase
    @scores = []
    self
  end

  def viewDidAppear(animated)
    getHighscores
    super
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @scores.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    entry = @scores[indexPath.row]
    place = indexPath.row + 1
    name = entry['name']
    score = "%.2f" % entry['score']

    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.textLabel.text = "#{place}: #{name}, #{score} seconds"
    cell
  end

  def getHighscores
    json = fetchJSON("http://tinymaze.netmute.org/scores/?mode=#{@mode}")
    if json
      @scores = json
      view.reloadData
    end
  end

  def fetchJSON(url)
    errorPointer = Pointer.new(:object)
    data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:errorPointer)
    if data
      json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:errorPointer)
      if json
        return json.dup
      end
    end
    return nil
  end
end
