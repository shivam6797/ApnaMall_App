// import 'package:apnamall_ecommerce_app/core/utils/shared_prefs.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'address_event.dart';
// import 'address_state.dart';

// class AddressBloc extends Bloc<AddressEvent, AddressState> {
//   AddressBloc() : super(AddressInitial()) {
//     on<SaveAddressEvent>((event, emit) async {
//       await SharedPrefs.saveAddress(event.address);
//       emit(AddressSaved(address: event.address));
//     });

//     on<LoadAddressEvent>((event, emit) async {
//       final address = await SharedPrefs.getAddress();
//       if (address != null) {
//         emit(AddressLoaded(address: address));
//       } else {
//         emit(AddressInitial());
//       }
//     });
//   }
// }
