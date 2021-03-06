import 'dart:html';

import 'package:angular/angular.dart';
import 'package:quickpin/rest_api.dart';
import 'package:route_hierarchical/client.dart';

/// Handles server-sent events.
@Injectable()
class SseController {
    Stream<Event> onAvatar;
    Stream<Event> onLabel;
    Stream<Event> onProfile;
    Stream<Event> onProfilePosts;
    Stream<Event> onProfileRelations;
    Stream<Event> onProfileNotes;
    Stream<Event> onWorker;

    RestApiController _api;
    EventSource _eventSource;

    /// Constructor
    SseController(this._api) {
        String url = this._api.authorizeUrl('/api/notification/');
        this._eventSource = new EventSource(url);

        this._eventSource.onError.listen((Event e) {
            window.console.log('Error connecting to SSE!');
        });

        // Set up event streams.
        this.onAvatar = this._eventSource.on['avatar'];
        this.onLabel = this._eventSource.on['label'];
        this.onProfile = this._eventSource.on['profile'];
        this.onProfilePosts = this._eventSource.on['profile_posts'];
        this.onProfileRelations = this._eventSource.on['profile_relations'];
        this.onProfileNotes = this._eventSource.on['profile_notes'];
        this.onWorker = this._eventSource.on['worker'];
    }
}

/// A helper that unsubscribes a list of subscriptions when leaving a route.
///
/// This saves a lot of boilerplate code in each controller.
void UnsubOnRouteLeave(RouteHandle rh, List<StreamSubscription> listeners) {
    rh.onLeave.take(1).listen((e) {
        listeners.forEach((listener) => listener.cancel());
    });
}
