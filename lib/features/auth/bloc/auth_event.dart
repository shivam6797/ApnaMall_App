abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String firstName,lastName ,email, password, mobile;
  SignUpRequested(this.firstName,this.lastName, this.email, this.password, this.mobile);
}

class LoginRequested extends AuthEvent {
  final String email, password;
  LoginRequested(this.email, this.password);
}
