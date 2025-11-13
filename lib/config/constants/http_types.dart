/// HTTP methods enum for API requests
enum HttpMethod { get, post, patch, delete }

/// Supabase table endpoints
/// Each endpoint makes a reference to a Supabase entity/table
enum Endpoint {
  heartRate,
  bloodPressure,
  temperature,
  respiratoryRate,
  oxygenSaturation,
  glucose,
  painLevel,
  medication;

  String get url => switch (this) {
        Endpoint.heartRate => 'heart_rate',
        Endpoint.bloodPressure => 'blood_pressure',
        Endpoint.temperature => 'temperature',
        Endpoint.respiratoryRate => 'respiratory_rate',
        Endpoint.oxygenSaturation => 'oxygen_saturation',
        Endpoint.glucose => 'glucose',
        Endpoint.painLevel => 'pain_level',
        Endpoint.medication => 'medications',
      };
}
