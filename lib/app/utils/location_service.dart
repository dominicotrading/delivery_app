import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Validates if the given coordinates are valid
  static bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 && 
           longitude >= -180 && longitude <= 180;
  }
  
  /// Converts coordinates to location name using reverse geocoding
  static Future<String> getLocationNameFromCoordinates(
    double latitude, 
    double longitude,
  ) async {
    try {
      if (!isValidCoordinates(latitude, longitude)) {
        return 'Invalid coordinates';
      }
      
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        // Build location name from available components
        List<String> locationParts = [];
        
        if (place.locality?.isNotEmpty == true) {
          locationParts.add(place.locality!);
        }
        if (place.subLocality?.isNotEmpty == true) {
          locationParts.add(place.subLocality!);
        }
        if (place.administrativeArea?.isNotEmpty == true) {
          locationParts.add(place.administrativeArea!);
        }
        if (place.country?.isNotEmpty == true) {
          locationParts.add(place.country!);
        }
        
        if (locationParts.isNotEmpty) {
          return locationParts.join(', ');
        } else {
          return 'Unknown location';
        }
      }
      
      return 'Location not found';
    } catch (e) {
      print('Error getting location name: $e');
      return 'Error getting location';
    }
  }
  
  /// Gets a short location name (city, country)
  static Future<String> getShortLocationName(
    double latitude, 
    double longitude,
  ) async {
    try {
      if (!isValidCoordinates(latitude, longitude)) {
        return 'Invalid coordinates';
      }
      
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        List<String> locationParts = [];
        
        if (place.locality?.isNotEmpty == true) {
          locationParts.add(place.locality!);
        }
        if (place.country?.isNotEmpty == true) {
          locationParts.add(place.country!);
        }
        
        if (locationParts.isNotEmpty) {
          return locationParts.join(', ');
        }
      }
      
      return 'Unknown location';
    } catch (e) {
      print('Error getting short location name: $e');
      return 'Error getting location';
    }
  }
  
  /// Gets detailed location information including street address
  static Future<Map<String, String>> getDetailedLocationInfo(
    double latitude, 
    double longitude,
  ) async {
    try {
      if (!isValidCoordinates(latitude, longitude)) {
        return {};
      }
      
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        Map<String, String> locationInfo = {};
        
        if (place.street?.isNotEmpty == true) {
          locationInfo['street'] = place.street!;
        }
        if (place.subLocality?.isNotEmpty == true) {
          locationInfo['subLocality'] = place.subLocality!;
        }
        if (place.locality?.isNotEmpty == true) {
          locationInfo['locality'] = place.locality!;
        }
        if (place.administrativeArea?.isNotEmpty == true) {
          locationInfo['administrativeArea'] = place.administrativeArea!;
        }
        if (place.country?.isNotEmpty == true) {
          locationInfo['country'] = place.country!;
        }
        if (place.postalCode?.isNotEmpty == true) {
          locationInfo['postalCode'] = place.postalCode!;
        }
        
        return locationInfo;
      }
      
      return {};
    } catch (e) {
      print('Error getting detailed location info: $e');
      return {};
    }
  }
  
  /// Gets a formatted address string
  static Future<String> getFormattedAddress(
    double latitude, 
    double longitude,
  ) async {
    try {
      if (!isValidCoordinates(latitude, longitude)) {
        return 'Invalid coordinates';
      }
      
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        List<String> addressParts = [];
        
        if (place.street?.isNotEmpty == true) {
          addressParts.add(place.street!);
        }
        if (place.subLocality?.isNotEmpty == true) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality?.isNotEmpty == true) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea?.isNotEmpty == true) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country?.isNotEmpty == true) {
          addressParts.add(place.country!);
        }
        
        if (addressParts.isNotEmpty) {
          return addressParts.join(', ');
        }
      }
      
      return 'Address not available';
    } catch (e) {
      print('Error getting formatted address: $e');
      return 'Error getting address';
    }
  }
}
