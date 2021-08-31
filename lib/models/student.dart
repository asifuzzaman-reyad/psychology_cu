class Student{
  Student({
    this.batch,
    this.id,
    this.session,
    this.name,
    this.mobile,
    this.email,
    this.hall,
    this.imageUrl,
});
  String? batch;
  String? id;
  String? session;
  String? name;
  String? mobile;
  String? email;
  String? hall;
  String? imageUrl;

  Map<String, dynamic> toJson() => {
   'batch' : batch,
   'id' : id,
   'session' : session,
   'name' : name,
   'mobile' : mobile,
   'email' : email,
   'hall' : hall,
   'imageUrl' : imageUrl,
  };
}