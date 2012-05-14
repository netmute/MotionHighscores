class JSONTableViewController < UITableViewController
  def initWithHighscore(mode)
    if init
      self.title = mode
      @mode = mode.downcase
      @scores = []
      getHighscores
      @refreshHeaderView ||= begin
        rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
        rhv.delegate = self
        rhv.refreshLastUpdatedDate
        tableView.addSubview(rhv)
        rhv
      end
    end
    self
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

  def reloadTableViewDataSource
    @reloading = true
    getHighscores
  end

  def doneReloadingTableViewData
    @reloading = false
    @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)
    @refreshHeaderView.refreshLastUpdatedDate
    view.reloadData
  end

  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)
  end

  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end

  def refreshTableHeaderDidTriggerRefresh(view)
    reloadTableViewDataSource
    performSelector('doneReloadingTableViewData', withObject:nil, afterDelay:0)
  end

  def refreshTableHeaderDataSourceIsLoading(view)
    @reloading
  end

  def refreshTableHeaderDataSourceLastUpdated(view)
    NSDate.date
  end
end
