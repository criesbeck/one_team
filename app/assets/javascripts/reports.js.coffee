jQuery ->
  $('.report').dataTable({
  "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
  "sPaginationType": "bootstrap"});

  Morris.Line({
    element: 'activity_changes_chart'
    data: $('#activity_changes_chart').data('changes')
    xkey: 'month'
    ykeys: ['requests', 'requests_w_responses', 'requests_w_assignments', 'cancellations']
    labels: ['Requests', 'Requests with Responses', 'Requests with Selections', 'Cancelled Requests']
  })

  $('#skilltab').one 
    click: (e) ->
      e.preventDefault()
      setTimeout ( ->
        Morris.Bar({
          element: 'developerskillinterests'
          data: $('#developerskillinterests').data('skillinterests')
          xkey: 'skill'
          ykeys: ['boston', 'chicago', 'mumbai', 'houston', 'london', 'san_francisco']
          labels: ['Boston', 'Chicago', 'Mumbai', 'Houston', 'London', 'San Francisco']
          })
        Morris.Bar({
          element: 'averageskilllevels'
          data: $('#averageskilllevels').data('averageskills')
          xkey: 'skill'
          ykeys: ['boston', 'chicago', 'mumbai', 'houston', 'london', 'san_francisco']
          labels: ['Boston', 'Chicago', 'Mumbai', 'Houston', 'London', 'San Francisco']
          })
      ), 1

  $('#impacttab').one
    click: (e) ->
      e.preventDefault()
      setTimeout ( ->
        Morris.Bar({
          element: 'sharedthree'
          data: $('#sharedthree').data('shared3')
          xkey: 'location'
          ykeys: ['boston', 'chicago', 'mumbai', 'houston', 'london', 'san_francisco']
          labels: ['Boston', 'Chicago', 'Mumbai', 'Houston', 'London', 'San Francisco']
          })
        Morris.Bar({
          element: 'sharedsix'
          data: $('#sharedsix').data('shared6')
          xkey: 'location'
          ykeys: ['boston', 'chicago', 'mumbai', 'houston', 'london', 'san_francisco']
          labels: ['Boston', 'Chicago', 'Mumbai', 'Houston', 'London', 'San Francisco']
          })
      ), 1