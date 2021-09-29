enum AuthState {
  authenticated,
  failed,
  otpSent,
  invalid,
  savingData,
  readyForUser,
  noUserExist
}

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  OtpSent,
}

enum ProductType { Vegetables, Fruits, Spices, Carbs, Bakery }

const Map<ProductType, String> ProductTypeMap = {
  ProductType.Vegetables: "Vegetable",
  ProductType.Fruits: "Fruits",
  ProductType.Spices: "Spices",
  ProductType.Carbs: "Carbs",
  ProductType.Bakery: "Bakery",
};
