%Keep bb equivalent around for checking later
bb_tot = zeros(size(cur_data_iq,1),size(cur_data_iq,3));

%Actual harmonic frequencies are necessary for later comb filter correction
harmonic_freqs = zeros(size(cur_data_iq,1),num_harmonics_present+1);

%Extract amplitude, phase measurements from entire dataset
square_noise = 0;
square_noise_count = 0;
square_phasors = zeros(size(anchor_positions,1),size(cur_iq_data,2),(num_harmonics_present+1));
for cur_anchor_idx = 1:size(anchor_positions,1)
	for cur_freq_step = 1:size(cur_iq_data,2)
		harmonic_idx = 1;
		for harmonic_num = -num_harmonics_present:2:num_harmonics_present
            harmonic_freq = (...
                square_est*harmonic_num+...
                carrier_offset+...
                (carrier_segment-cur_freq_step)*(step_freq-square_est*(step_freq/square_freq)));
			cur_bb = exp(-1i*(0:size(cur_iq_data,3)-1)*2*pi*harmonic_freq...
                /(sample_rate/decim_factor)); %TODO: Review cur_freq_step addition
			square_phasors(cur_anchor_idx,cur_freq_step,harmonic_idx) = sum(cur_bb .* squeeze(cur_iq_data(cur_anchor_idx,cur_freq_step, :)).');
            
            %Get next bin to determine SNR
            cur_bb = cur_bb.*exp(1i*(0:size(cur_iq_data,3)-1)*2*pi/size(cur_iq_data,3));
            square_noise = square_noise + abs(sum(cur_bb.*squeeze(cur_iq_data(cur_anchor_idx,cur_freq_step,:)).'));
            square_noise_count = square_noise_count + 1;

			bb_tot(cur_freq_step,:) = bb_tot(cur_freq_step,:) + conj(cur_bb);
            harmonic_freqs(cur_freq_step,harmonic_idx) = harmonic_freq;
            
			harmonic_idx = harmonic_idx + 1;
		end
	end
end

square_noise = square_noise / square_noise_count;

harmonic_freqs_abs = zeros(size(data_iq,2),num_harmonics_present+1);
for ii=1:size(harmonic_freqs_abs,1)
	harmonic_freqs_abs(ii,:) = harmonic_freqs(ii,:) + start_lo_freq + if_freq + step_freq*(ii-1);
end