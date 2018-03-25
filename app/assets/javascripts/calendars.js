
$(document).on("turbolinks:load", function() {
  var container = document.getElementById('calendar-schedule');

  if (! container) {
     console.log('container not found, exiting!');
    return;
  }

  var names = ['John', 'Alston', 'Lee', 'Grant'];
  var groups = new vis.DataSet();

  var data = [];
  var group_ids = {};
  $('#calendar-schedule').data().calendarEvents.forEach(function(event) {
    group_id = event.user_id;
    if (!group_ids[group_id]) {
      group_ids[group_id] = true;
      groups.add({id: group_id, content: event.user_id});
    }
    data.push({
      id: event.id,
      group: event.user_id,
      content: 'item',
      start: event.start_at,
      end: event.end_at
    })
  })

  // for (var g = 0; g < 3; g++) {
  //   groups.add({id: g, content: names[g]});
  // }

  // Create a DataSet (allows two way data-binding)
  //  types could be [ 'box', 'point', 'range']
  var items = new vis.DataSet(data);

  //[
  //  {id: 1, group: 0, content: 'item 1', start: '2018-04-20', end: '2018-04-21'},
  //  {id: 2, group: 1, content: 'item 2', start: '2018-04-14', end: '2018-04-16'},
  //  {id: 3, group: 2, content: 'item 3', start: '2018-04-18', end: '2018-04-21'},
  //  {id: 4, group: 0, content: 'item 4', start: '2018-04-16', end: '2014-04-19'},
  //  {id: 5, group: 1, content: 'item 5', start: '2018-04-25', end: '2014-04-27'},
  //  {id: 6, group: 2, content: 'item 6', start: '2018-04-27', end: '2014-04-28'}
  //]);

  function updateSchedule() {
    var data = items.get({
      type: { start: 'ISODate', end: 'ISODate' }
    });

    console.log('Updating schedule: ', data);
  }

  function loadData() {
    // get and deserialize the data
    var data = JSON.parse(txtData.value);

    // items.clear();
    // items.add(data);
    items.update(data);

    // adjust the timeline window such that we see the loaded data
    timeline.fit();
  }


  // Configuration for the Timeline
  var options = {
    //clickToUse: true,

    multiselect: true,
    groupOrder: 'content',
    editable: true,

    // always snap to full hours, independent of the scale
    snap: function (date, scale, step) {
      var hour = 60 * 60 * 1000;
      return Math.round(date / hour) * hour;
    },

    onAdd: function (item, callback) {
      console.log('onAdd', item);
      if (!item.end) {
        item.end = item.start
      }
      callback(item);
    },
    onMove: function (item, callback) {
      console.log('onMove', item);
      //callback(null);
      callback(item);
    },
    onUpdate: function (item, callback) {
      console.log('onUpdate', item);
      //callback(null);
      callback(item);
    },
    onRemove: function (item, callback) {
      console.log('onRemove', item);
      //callback(null);
      callback(item);
    }

  };

  // Create a Timeline
  var timeline = new vis.Timeline(container);
  timeline.setOptions(options);
  timeline.setGroups(groups);
  timeline.setItems(items);
  console.log('Timeline initialized!');
})
