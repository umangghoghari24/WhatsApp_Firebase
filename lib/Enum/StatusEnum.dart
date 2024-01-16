//
// enum StatusEnum {
//   text('text'),
//   image('image'),
//   audio('audio'),
//   gif('gif');
//
//
//   const StatusEnum(this.type);
//   final String type;
//
// }
//
// extension ConverMessage on String {
//   StatusEnum toEnum() {
//     switch (this) {
//       case 'audio':
//         return StatusEnum.audio;
//       case 'image':
//         return StatusEnum.image;
//       case 'text':
//         return StatusEnum.text;
//       case 'gif':
//         return StatusEnum.gif;
//       default:
//         return StatusEnum.text;
//     }
//   }
// }