import 'package:flutter_map/flutter_map.dart';

class MarkerClusterPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is MarkerClusterLayerOptions) {
      return MarkerClusterLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for MarkerClusterPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is MarkerClusterLayerOptions;
  }
}