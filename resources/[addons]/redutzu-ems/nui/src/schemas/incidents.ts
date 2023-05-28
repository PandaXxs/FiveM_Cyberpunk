import * as yup from 'yup';

const schema = yup.object().shape({
    name: yup.string().min(3, 'errors.incidents.name.length').required('errors.incidents.name.required'),
    description: yup.string().min(10, 'errors.incidents.description.length').required('errors.incidents.description.required'),
    players: yup.array().min(1, 'errors.incidents.players.length').required('errors.incidents.players.required'),
    doctors: yup.array().min(1, 'errors.incidents.doctors.length').required('errors.incidents.doctors.required'),
    images: yup.array().required(),
    invoices: yup.array(),
    invoice_reduction: yup.number()
});

export default schema;