var mrpCalendar = (function (window, document) {
    // most of the code taken from https://github.com/ingoboerner
    //https://github.com/martinantonmueller/Hermann-Bahr_Arthur-Schnitzler/blob/master/app/resources/js/calendar.js
    var datasource = "../analyze/calendar_datasource.xql";
    var calendarRootElement;
    var calendarInstance;

    var localeDateOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    var maxPopoverEntryLength = 500;

    var $disabledDays = [];
    var allPopoverContainers = [];

    var killPopoverGracePeriodMs = 750;
    var killPopoverAfterTimeout = false;

    $(document).ready(function () {
        calendarRootElement = document.getElementById('calendar'); // $('#calendar');
        calendarInstance = new Calendar(
            calendarRootElement,
            {
                dataSource: loadDataForYear,
                language: 'de',
                startYear: 1852,
                minDate: new Date(1848, 0, 1),
                maxDate: new Date(1918, 11, 30),
                weekStart: 1, // week starts on monday,
                disabledDays: $disabledDays,
                style: 'background',

                mouseOnDay: handleEnterDay,
                mouseOutDay: handleLeaveDay,
                clickDay: openDateLink
            }
        );

        document.addEventListener('click', function (ev) {
            // Any click removes all popovers
            removeAllPopovers();
            disablePopoverKill();
        });

        $('#calendar').on('inserted.bs.popover', function (insertEvent) {
            // Add pointer enter and leave functions to all popover bubbles
            var target = insertEvent.currentTarget;
            var popoverElements = target.getElementsByClassName('popover');
            for (var i = 0; i < popoverElements.length; i++) {
                var e = popoverElements[i];
                e.addEventListener('pointerleave', function () {
                    removeAllPopovers();
                    disablePopoverKill();
                });
                e.addEventListener('pointerenter', function () {
                    disablePopoverKill();
                })
                var childElementBoxes = e.getElementsByClassName('event-tooltip-entry');
                for (var j = 0; j < childElementBoxes.length; j++) {
                    var item = childElementBoxes[j];
                    item.addEventListener('pointerenter', function () {
                        disablePopoverKill();
                    });
                }
            }
        });
    });

    var loadDataForYear = function (year) {
        return fetch(datasource + `?year=${year}`)
            .then(result => result.json())
            .catch(reason => {
                window.console.log('Error loading calendar data:');
                window.console.log(reason);
                return [];
            })
            .then(json_data => json_data.map(convertDbObjectToCalendarObject))
            .catch(reason => []);
    };

    var handleEnterDay = function (ev) {
        var thisDayHasAnAssociatedPopover = (ev.events.length !== 0);
        if (thisDayHasAnAssociatedPopover) {
            removeAllPopovers();

            var popoverContent = createPopoverContent(ev);
            createAndShowNewPopover(ev.element, ev.date, popoverContent);

            disablePopoverKill();
        }
    };

    var handleLeaveDay = function (ev) {
        var thisDayHasAnAssociatedPopover = (ev.events.length !== 0);
        if (thisDayHasAnAssociatedPopover) {
            window.setTimeout(function () {
                if (killPopoverAfterTimeout) {
                    removeAllPopovers();
                }
            }, killPopoverGracePeriodMs)

            enablePopoverKill();
        }
    };

    var convertDbObjectToCalendarObject = function (eObj) {
        var j = eObj.startDate.substring(0, 4);
        var m = eObj.startDate.substring(5, 7);
        var d = eObj.startDate.substring(8, 10);
        var bothDates = new Date(j, m - 1, d);
        return {
            id: eObj.id,
            name: eObj.name,
            color: '#286090',
            startDate: bothDates,
            endDate: bothDates
        };
    };

    var createPopoverContent = function (e) {
        if (e.events.length > 0) {
            var content = '<div class="event-tooltip-content">';
            for (var i in e.events) {
                var item_name = (e.events[i].name !== '' ? e.events[i].name : '&lt;kein Titel&gt;');
                if (item_name.length > maxPopoverEntryLength) {
                    item_name = item_name.substring(0, maxPopoverEntryLength) + '...';
                }
                content += '<a class="event-tooltip-entry" href="' + e.events[i].id + '" target="_blank">' + item_name + '</a>'
            }
            content += '</div>';
            return content;
        }
        else {
            return null;
        }
    };

    var createAndShowNewPopover = function (dayElement, date, content) {
        var container = $(dayElement);
        var title = date.toLocaleDateString('de', localeDateOptions);
        container.popover({
            title: title,
            trigger: 'manual',
            container: calendarRootElement,
            html: true,
            delay: { 'hide': 400 },
            content: content
        });
        allPopoverContainers.push(container);
        container.popover('show');
    };

    var removeAllPopovers = function () {
        while (allPopoverContainers.length > 0) {
            var existingContainer = allPopoverContainers.pop();
            existingContainer.popover('dispose');
        }
    }

    var enablePopoverKill = function () {
        killPopoverAfterTimeout = true;
    };

    var disablePopoverKill = function () {
        killPopoverAfterTimeout = false;
    };

    var openDateLink = function (e) {
        var ids = [];
        $.each(e.events, function (key, entry) {
            ids.push(entry.id)
        });
        if (e.events.length === 1) { // avoids having broken links - an else with a modal, link bubble or some other solution would be nice to have
            // window.location = ids.join()
            window.open(ids[0], target = "_blank");
        } else if (e.events.length === 0) { // no clicking on no event dates!
        } else {
            $.each(ids, function (i, val) {
                console.log(val)

            })
            // window.location = ids[1]
            window.open(ids[1], target = "_blank");
        }
    };

})(window, document);
